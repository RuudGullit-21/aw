#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает действующий на указанную дату документ, удостоверяющий личность
//
// Параметры
//	Физлицо			- физическое лицо, для которого необходимо получить документ
//	Дата			- дата, на которую необходимо получить документ
//
// Возвращаемое значение
//	Представление		- строка - представление документа, удостоверяющего личность
//
Функция ДокументУдостоверяющийЛичностьФизлица(Физлицо, Дата = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",	Физлицо);
	Запрос.УстановитьПараметр("ДатаСреза",	Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДокументыФизическихЛиц.Представление
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			" + ?(Дата <> Неопределено, "И ДокументыФизическихЛиц.Период <= &ДатаСреза", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	УдостоверениеЛичности = Новый Структура("Представление, ЕстьУдостоверение");
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Представление;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Функция проверяет, является-ли указанный вид документа документом, удостоверяющим личность для этого физлица
//
// Параметры
//	Физлицо			- физическое лицо, для которого необходимо получить документ
//	ВидДокумента	- вид документа, удостоверяющего личность
//	Дата			- дата, на которую необходимо получить документ
//
// Возвращаемое значение
//	Является		- булево - является ли указанный вид документа документом, удостоверяющим личность
//
Функция ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Физлицо) Или НЕ ЗначениеЗаполнено(ВидДокумента) Или Не ЗначениеЗаполнено(Дата) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",		Физлицо);
	Запрос.УстановитьПараметр("ВидДокумента",	ВидДокумента);
	Запрос.УстановитьПараметр("ДатаСреза",		Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументыФизическихЛиц.ВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			И ДокументыФизическихЛиц.Период < &ДатаСреза
	|			И ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента)";
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли