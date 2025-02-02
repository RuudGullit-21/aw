////////////////////////////////////////////////////////////////////////////////
//  Процедуры и функции, обеспечивающие работу генератора финансовых отчетов
//  для получения финансовой отчетности
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Разворачивает дерево сохраненных элементов
//
// Параметры:
//  Форма					 - Управляемая форма
//  ДанныеДереваЭлементов	 - Элемент - Дерево
//
Процедура РазвернутьДеревоСохраненныхЭлеметов(Форма, ДанныеДереваЭлементов) Экспорт
	
	НайденныеЭлементы = ДанныеДереваЭлементов.ПолучитьЭлементы();
	Если НайденныеЭлементы.Количество() = 1 Тогда
		ИдентификаторСтроки = НайденныеЭлементы[0].ПолучитьИдентификатор();
		Форма.Элементы.ДеревоСохраненныхЭлементов.Развернуть(ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

#Область ПроцедурыИФункцииРасшифровкиОтчета

// Выполняет обработку расшифровки отчета
//
// Параметры:
//  ФормаОтчета - Форма отчета
//  Элемент	 - Элемент формы - Табличный документ
//  Расшифровка	 - Значение расшифровки
//
Процедура ОбработкаРасшифровкиОтчета(ФормаОтчета, Элемент, Расшифровка) Экспорт
	
	ПараметрыОтчета = НовыеПараметрыОтчета();
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ФормаОтчета);
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, ФормаОтчета.Отчет);
	ПараметрыОтчета.Вставить("Значение", Элемент.ТекущаяОбласть.Текст);
	ПараметрыОтчета.АдресНастроек = ПоместитьВоВременноеХранилище(Неопределено, ФормаОтчета.УникальныйИдентификатор);
	ПараметрыРасшифровки = МеждународнаяОтчетностьВызовСервера.ПараметрыРасшифровкиОтчета(Расшифровка, ПараметрыОтчета);
	
	Если ПараметрыРасшифровки = Неопределено ИЛИ ПараметрыРасшифровки.Показатель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Показатель = ПараметрыРасшифровки.Показатель;
	Если Показатель.ВидЭлемента = ВидЭлемента("МонетарныйПоказатель") Тогда
		ПоказатьЗначение(Неопределено, Показатель.ЭлементОтчета);
	ИначеЕсли Показатель.ВидЭлемента = ВидЭлемента("ПроизводныйПоказатель") Тогда
		ПараметрыФормы = Новый Структура("СформироватьОтчет", Истина);
		ПараметрыФормы.Вставить("ПараметрыРасшифровки", ПараметрыРасшифровки);
		ОткрытьФорму("Отчет.ГенераторФинансовойОтчетности.Форма", ПараметрыФормы, ФормаОтчета, Истина);
		
	ИначеЕсли Показатель.ВидЭлемента = ВидЭлемента("НемонетарныйПоказатель") Тогда
		ПоказатьЗначение(Неопределено, Показатель.НемонетарныйПоказатель);
		
	ИначеЕсли ПараметрыОтчета.ВидОтчета <> Показатель.Владелец
		И ЗначениеЗаполнено(Показатель.Владелец) Тогда
		ПараметрыФормы = Новый Структура("СформироватьОтчет", Истина);
		ПараметрыРасшифровки.ВидОтчета = Показатель.Владелец;
		Если ПараметрыРасшифровки.Показатель.ВидЭлемента = ВидЭлемента("ИтогПоГруппе") Тогда
			ПараметрыРасшифровки.Показатель = ПараметрыРасшифровки.ПустаяСсылка;
		КонецЕсли;
		ПараметрыФормы.Вставить("ПараметрыРасшифровки", ПараметрыРасшифровки);
		ОткрытьФорму("Отчет.ГенераторФинансовойОтчетности.Форма.ФормаОтчета", ПараметрыФормы, ФормаОтчета, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Функция НовыеПараметрыОтчета()
	
	Результат = Новый Структура;
	Результат.Вставить("ВидОтчета");
	Результат.Вставить("КомплектОтчетности");
	Результат.Вставить("НачалоПериода");
	Результат.Вставить("КонецПериода");
	Результат.Вставить("ДанныеРасшифровки");
	Результат.Вставить("АдресНастроек");
	Результат.Вставить("Организация");
	Результат.Вставить("Подразделение");
	Результат.Вставить("Ресурс");
	Результат.Вставить("ДанныеПоказателя");
	Возврат Результат;
	
КонецФункции

#Область РаботаСФормулами

// Функция добавляет новые операнды в таблицу операндов
//
// Параметры:
//  Форма  - УправляемаяФорма - Форма конструктора формул
//  НовыеОперанды  - Массив - Строки дерева операндов
//  ТаблицаОперандов - ТаблицаЗначений - Таблица выбранных в формуле операндов
//  Уникальный - Булево - признак уникальности операндов (добавлять операнды если есть)
//
// Возвращаемое значение:
//   Массив   - массив добавленных строк таблицы операндов
//
Функция ДобавитьОперандыФормулы(Форма, НовыеОперанды, ТаблицаОперандов, Уникальный = Истина) Экспорт
	
	ТипИтога = ПредопределенноеЗначение("Перечисление.ТипыИтогов.СальдоДт");
	МассивДобавленных = Новый Массив;
	Для Каждого Операнд Из НовыеОперанды Цикл
		
		Если Операнд.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		
		Идентификатор = ИмяОперанда(Операнд, ТаблицаОперандов, Уникальный);
		НайденныйОперанд = Неопределено;
		Если ЕстьПоказатель(Идентификатор, ТаблицаОперандов, НайденныйОперанд) Тогда
			МассивДобавленных.Добавить(НайденныйОперанд);
		ИначеЕсли Операнд.ЭтоСвязанный Тогда
			ДобавитьСохраненныйОперанд(Форма, ТаблицаОперандов, Операнд, МассивДобавленных);
		Иначе
			НоваяСтрока = ТаблицаОперандов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Операнд,,"ЭтоСвязанный");
			НоваяСтрока.Идентификатор = Идентификатор;
			НоваяСтрока.СчетПланаСчетов = Операнд.ЭлементВидаОтчетности;
			НоваяСтрока.ТипИтога = ТипИтога;
			НоваяСтрока.СчетПоказательИзмерение = Операнд.ЭлементВидаОтчетности;
			МассивДобавленных.Добавить(НоваяСтрока);
		КонецЕсли;
		
		Если НЕ Форма.Модифицированность Тогда
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДобавленных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВидЭлемента(ИмяВидаЭлемента)
	
	Возврат ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета."+ИмяВидаЭлемента);
	
КонецФункции

Функция ЕстьПоказатель(Идентификатор, ТаблицаОперандов, НайденныйОперанд = Неопределено)
	
	Для Каждого СтрокаОперанда из ТаблицаОперандов Цикл
		Если СтрокаОперанда.Идентификатор = Идентификатор Тогда
			НайденныйОперанд = СтрокаОперанда;
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ИмяОперанда(Операнд, ТаблицаОперандов, Уникальный = Истина)
	
	Если Операнд.Свойство("СчетПланаСчетов") И ЗначениеЗаполнено(Операнд.СчетПланаСчетов) Тогда
		Результат = "Сч" + Операнд.Код;
	Иначе
		Попытка
			Результат = "П" + Формат(Число(Операнд.Код), "ЧН=0; ЧГ=0");
		Исключение
			Результат = "П" + Операнд.Код;
		КонецПопытки;
	КонецЕсли;
	
	Идентификатор = Результат;
	Если Не Уникальный Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	Сч = 0;
	Пока ЕстьПоказатель(Идентификатор, ТаблицаОперандов) Цикл
		Сч = Сч + 1;
		Идентификатор = Результат + "_" + Формат(Сч, "ЧГ=");
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура ДобавитьСохраненныйОперанд(Форма, ТаблицаОперандов, Операнд, МассивДобавленных)

	ДанныеОперанда = МеждународнаяОтчетностьКлиентСервер.НовыеДанныеОперанда();
	ЗаполнитьЗначенияСвойств(ДанныеОперанда,Операнд);
	Добавлено = МеждународнаяОтчетностьВызовСервера.ДобавитьСохраненныйОперанд( 
					ДанныеОперанда, 
					Форма.ИдентификаторГлавногоХранилища);
	
	Для Каждого НовыйОперанд Из Добавлено.НовыеОперанды Цикл
		НоваяСтрока = ТаблицаОперандов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НовыйОперанд);
		Если ПустаяСтрока(НоваяСтрока.Идентификатор) Тогда
			НоваяСтрока.Идентификатор = ИмяОперанда(НовыйОперанд, ТаблицаОперандов);
		КонецЕсли;
		МассивДобавленных.Добавить(НовыйОперанд);
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(Добавлено.Формула) Тогда
		Если НЕ ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = Форма.Формула + Символы.ПС;
		КонецЕсли;
		Форма.Формула = Форма.Формула + Добавлено.Формула;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
