#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Заглушка = Истина;
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если НЕ уатОбщегоНазначенияСервер.РазрешениеПечатиНепроведенногоДокумента(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Возврат;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	
КонецПроцедуры // Печать

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет переопределить ограничение, указанное в модуле менеджера объекта метаданных.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	Заглушка = Истина;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	СформироватьТаблицаСостояниеТС(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПланированияРаботыТС(ДокументСсылка, СтруктураДополнительныеСвойства);
	Если ДокументСсылка.Рассчитан Тогда
		СформироватьТаблицаСчетчикиТС(ДокументСсылка, СтруктураДополнительныеСвойства);
		СформироватьТаблицаВыработкаТС(ДокументСсылка, СтруктураДополнительныеСвойства);
		СформироватьТаблицаГСМ(ДокументСсылка, СтруктураДополнительныеСвойства);
		СформироватьТаблицаРасходГСМ(ДокументСсылка, СтруктураДополнительныеСвойства);
		СформироватьТаблицаИзносПробегШин(ДокументСсылка, СтруктураДополнительныеСвойства);
		Если уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, "УчетРабочегоВремени") Тогда
			СформироватьТаблицаРабочееВремяРаботниковОрганизаций(ДокументСсылка, СтруктураДополнительныеСвойства);
		КонецЕсли;
		СформироватьТаблицаРасходы(ДокументСсылка, СтруктураДополнительныеСвойства);
	КонецЕсли;
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	Если ДокументСсылка.Рассчитан Тогда
		Для Каждого ТекСтрока Из ДокументСсылка.РасходГСМ Цикл
			Если НЕ ТекСтрока.Активен Тогда
				Продолжить;
			КонецЕсли;
			
			МоментВремени = Новый Граница(ДокументСсылка.ДатаВозвращения, ВидГраницы.Включая);
			
			ОстатокГСМ = уатОбщегоНазначения.уатОстатокГСМнаТС(МоментВремени, ТекСтрока.ТС, ТекСтрока.ГСМ, ДокументСсылка);
			Если ОстатокГСМ < 0 Тогда
				ТекстНСТР = НСтр("en='Fuels ""%1"",vehicle ""%2"" - negative remains of fuels in vehicle (%3).';ru='ГСМ ""%1"", ТС ""%2"" - отрицательный остаток ГСМ в ТС (%3).'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрока.ГСМ, Строка(ТекСтрока.ТС), ОстатокГСМ);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры 

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура формирует таблицу рабочего времени сотрудников
// для дальнейшего формирования табеля рабочего времени
Процедура ФормированиеТаблицыРабочегоВремениДляТабеля(ТаблицаДвижений, ДокументСсылка, СтруктураДополнительныеСвойства, ВыборВодитель = Неопределено)
	мсвВодители = Новый Массив;
	Если ЗначениеЗаполнено(ДокументСсылка.Водитель) Тогда
		мсвВодители.Добавить(ДокументСсылка.Водитель);
	КонецЕсли;
		
	// добавляем Явку и Ночные
	тблРабочееВремя = уатПутевыеЛисты.РасчетВремени(ДокументСсылка.ДатаВыезда, ДокументСсылка.ДатаВозвращения, ДокументСсылка.Организация,
		Справочники.уатРежимыРаботыТС.ПустаяСсылка(), Новый ТаблицаЗначений);
	Для Каждого ТекВодитель Из мсвВодители Цикл
		Для Каждого ТекСтрокаВремя Из тблРабочееВремя Цикл
			Если ЗначениеЗаполнено(ТекСтрокаВремя.Продолжительность)
				И (ТекСтрокаВремя.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.Явка
				ИЛИ ТекСтрокаВремя.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.РаботаНочныеЧасы) Тогда
				
				Движение = ТаблицаДвижений.Добавить();
				Движение.Период = ДокументСсылка.ДатаВозвращения;
				Движение.ДатаРаботы = ТекСтрокаВремя.ДатаРаботы;
				Движение.Организация = ДокументСсылка.Организация;
				Движение.Сотрудник = ТекВодитель;
				Движение.ВидИспользованияРабочегоВремени = ТекСтрокаВремя.ВидВремени;
				Движение.Дней = 1;
				Движение.Время = ТекСтрокаВремя.Продолжительность;
				
				// При необходимости согласно графику работы сотрудника заменяем явку на выходной или праздник
				Если ТекСтрокаВремя.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.Явка Тогда
					флПраздник = уатПутевыеЛисты.ПраздникПоГрафику(ТекВодитель, ДокументСсылка.Организация, ТекСтрокаВремя.ДатаРаботы);
					Если флПраздник Тогда
						Движение.ВидИспользованияРабочегоВремени = Справочники.уатВидыИспользованияРабочегоВремени.Праздники;
					Иначе
						флВыходной = уатПутевыеЛисты.ВыходнойПоГрафику(ТекВодитель, ДокументСсылка.Организация, ТекСтрокаВремя.ДатаРаботы);
						Если флВыходной Тогда
							Движение.ВидИспользованияРабочегоВремени = Справочники.уатВидыИспользованияРабочегоВремени.ВыходныеДни;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры  

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСостояниеТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблДвижений = Новый ТаблицаЗначений;
	тблДвижений.Колонки.Добавить("Регистратор");
	тблДвижений.Колонки.Добавить("Период");
	тблДвижений.Колонки.Добавить("ДатаОкончания");
	тблДвижений.Колонки.Добавить("ТС");
	тблДвижений.Колонки.Добавить("Состояние");
	
	НоваяСтрока = тблДвижений.Добавить();
	НоваяСтрока.ТС = ДокументСсылка.ТС;
	НоваяСтрока.Период = уатОбщегоНазначения.уатДатаБезСекунд(ДокументСсылка.ДатаВыезда);
	НоваяСтрока.ДатаОкончания = ДокументСсылка.ДатаВозвращения-1;
	НоваяСтрока.Состояние = Справочники.уатСостояниеТС.СформированПутевойЛист;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостоянийТС", тблДвижений);
КонецПроцедуры // СформироватьТаблицаСостояниеТС()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПланированияРаботыТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатТехнологическийПутевойЛист.Ссылка КАК Регистратор,
	|	уатТехнологическийПутевойЛист.Ссылка КАК ДокументПланирования,
	|	уатТехнологическийПутевойЛист.ДатаВыезда КАК ДатаНачала,
	|	уатТехнологическийПутевойЛист.ДатаВозвращения КАК ДатаОкончания,
	|	ЗНАЧЕНИЕ(СПРАВОЧНИК.уатСостояниеТС.СформированПутевойЛист) КАК Состояние,
	|	уатТехнологическийПутевойЛист.ТС КАК ТС
	|ИЗ
	|	Документ.уатТехнологическийПутевойЛист КАК уатТехнологическийПутевойЛист
	|ГДЕ
	|	уатТехнологическийПутевойЛист.Ссылка = &Ссылка";
	
	мЗапрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПланированияРаботыТС", МассивРезультатов[0].Выгрузить());
КонецПроцедуры // СформироватьТаблицаПланированияРаботыТС()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСчетчикиТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблДвижений = Новый ТаблицаЗначений;
	тблДвижений.Колонки.Добавить("Регистратор");
	тблДвижений.Колонки.Добавить("Период");
	тблДвижений.Колонки.Добавить("ТС");
	тблДвижений.Колонки.Добавить("ТипСчетчика");
	тблДвижений.Колонки.Добавить("Значение");
	
	Движение = тблДвижений.Добавить();
	Движение.Регистратор = ДокументСсылка;
	Движение.Период = ДокументСсылка.ДатаВозвращения-1;
	Движение.ТС = ДокументСсылка.ТС;
	Если ДокументСсылка.ТС.Модель.НаличиеСпидометра Тогда
		Движение.ТипСчетчика = Перечисления.уатТипыСчетчиковТС.Спидометр;
	Иначе
		Движение.ТипСчетчика = Перечисления.уатТипыСчетчиковТС.СчетчикМЧ;
	КонецЕсли;
	Движение.Значение = ДокументСсылка.ОдометрВозвращения;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСчетчиковТС", тблДвижений);
КонецПроцедуры // СформироватьТаблицаСчетчикиТС()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВыработкаТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатТехнологическийПутевойЛистВыработкаТС.Ссылка.ДатаВозвращения КАК Период,
	|	уатТехнологическийПутевойЛистВыработкаТС.ТС КАК ТС,
	|	уатТехнологическийПутевойЛистВыработкаТС.ПараметрВыработки КАК ПараметрВыработки,
	|	уатТехнологическийПутевойЛистВыработкаТС.Количество КАК Количество,
	|	уатТехнологическийПутевойЛистВыработкаТС.Подразделение КАК Подразделение,
	|	уатТехнологическийПутевойЛистВыработкаТС.Ссылка.Организация КАК Организация,
	|	уатТехнологическийПутевойЛистВыработкаТС.ОбъектСтроительства КАК ОбъектСтроительства,
	|	уатМестонахождениеТССрезПоследних.Колонна КАК Колонна
	|ИЗ
	|	Документ.уатТехнологическийПутевойЛист.ВыработкаТС КАК уатТехнологическийПутевойЛистВыработкаТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаВозвращения, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО уатТехнологическийПутевойЛистВыработкаТС.Ссылка.ТС = уатМестонахождениеТССрезПоследних.ТС
	|ГДЕ
	|	уатТехнологическийПутевойЛистВыработкаТС.Ссылка = &Док";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Док", ДокументСсылка);
	Запрос.УстановитьПараметр("ДатаВозвращения", ДокументСсылка.ДатаВозвращения);
	тблДвижений = Запрос.Выполнить().Выгрузить();
	
	УчетВыработкиПоПодразделениям = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.УчетВыработкиПоПодразделениям);
	УчетВыработкиПоОбъектамСтроительства = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.УчетВыработкиПоОбъектамСтроительства);
	Если НЕ УчетВыработкиПоПодразделениям Тогда
		тблДвижений.ЗаполнитьЗначения(Неопределено, "Подразделение");
	КонецЕсли;
	Если НЕ УчетВыработкиПоОбъектамСтроительства Тогда
		тблДвижений.ЗаполнитьЗначения(Неопределено, "ОбъектСтроительства");
	КонецЕсли;
	Если (НЕ УчетВыработкиПоПодразделениям) ИЛИ (НЕ УчетВыработкиПоОбъектамСтроительства) Тогда
		тблДвижений.Свернуть("Период, ТС, ПараметрВыработки, Подразделение, Организация, ОбъектСтроительства, Колонна", "Количество");
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыработкиТС", тблДвижений);
КонецПроцедуры // СформироватьТаблицаВыработкаТС()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаГСМ(ДокументСсылка, СтруктураДополнительныеСвойства)
	Перем мТаблицаПоСписаниюГСМ;
	
	// Подготовим таблицу ГСМ для проведения.
	СтрокаОшибки = "";
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	уатТехнологическийПутевойЛистРасходГСМ.ТС,
	|	уатТехнологическийПутевойЛистРасходГСМ.ГСМ
	|ИЗ
	|	Документ.уатТехнологическийПутевойЛист.РасходГСМ КАК уатТехнологическийПутевойЛистРасходГСМ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.уатНоменклатураГСМ КАК уатНоменклатураГСМ
	|		ПО (уатТехнологическийПутевойЛистРасходГСМ.ГСМ = уатНоменклатураГСМ.Номенклатура
	|				И уатНоменклатураГСМ.ГруппаГСМ = &ГруппаГСМ)
	|ГДЕ
	|	уатТехнологическийПутевойЛистРасходГСМ.Ссылка = &Ссылка";
	мЗапрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	мЗапрос.УстановитьПараметр("ГруппаГСМ", Перечисления.уатГруппыГСМ.Топливо);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатОстаткиГСМнаТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = мЗапрос.Выполнить();
	Для каждого КолонкаРезультатЗапроса Из ЭлементБлокировки.ИсточникДанных.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	//уатОбщегоНазначения.уатПодготовитьТаблицуСписанияГСМ(ДокументСсылка, мТаблицаПоСписаниюГСМ, Истина, , СтрокаОшибки);
	уатОбщегоНазначения_проф.уатПодготовитьТаблицуСписанияГСМ(ДокументСсылка, мТаблицаПоСписаниюГСМ, Истина, , СтрокаОшибки);
	мТаблицаПоСписаниюГСМ.Колонки.Дата.Имя = "Период";
	мТаблицаПоСписаниюГСМ.Колонки.Добавить("ВидДвижения");
	мТаблицаПоСписаниюГСМ.ЗаполнитьЗначения(ВидДвиженияНакопления.Расход, "ВидДвижения");
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаГСМ", мТаблицаПоСписаниюГСМ);
КонецПроцедуры // СформироватьТаблицаГСМ()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРасходГСМ(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблДвижений = Новый ТаблицаЗначений;
	тблДвижений.Колонки.Добавить("Период");
	тблДвижений.Колонки.Добавить("ТС");
	тблДвижений.Колонки.Добавить("Водитель");
	тблДвижений.Колонки.Добавить("ГСМ");
	тблДвижений.Колонки.Добавить("Колонна");
	тблДвижений.Колонки.Добавить("Организация");
	тблДвижений.Колонки.Добавить("РасходПоНорме");
	тблДвижений.Колонки.Добавить("РасходПоФакту");
	
	мТочностьОстатковГСМ = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива);
	
	Для Каждого ТекСтрокаРасходГСМ Из ДокументСсылка.РасходГСМ Цикл
		Если (ТекСтрокаРасходГСМ.РасходПоНорме <> 0 ИЛИ
			ТекСтрокаРасходГСМ.РасходПоФакту <> 0) И ТекСтрокаРасходГСМ.Активен Тогда
			
			ТекКолоннаТС = уатОбщегоНазначения.МестонахождениеТС(ТекСтрокаРасходГСМ.ТС, ДокументСсылка.ДатаВозвращения).Колонна;
			
			мОтбор = Новый Структура("ГСМ, ТС", ТекСтрокаРасходГСМ.ГСМ, ТекСтрокаРасходГСМ.ТС);
			мНайденныеСтроки = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГСМ.НайтиСтроки(мОтбор);
			Если мНайденныеСтроки.Количество() > 0 Тогда
				Если мНайденныеСтроки[0].Количество = ТекСтрокаРасходГСМ.РасходПоФакту Тогда
					НоваяСтрока 				= тблДвижений.Добавить();
					НоваяСтрока.Период 			= ДокументСсылка.ДатаВозвращения;
					НоваяСтрока.ТС 				= ТекСтрокаРасходГСМ.ТС;
					НоваяСтрока.Водитель 		= ДокументСсылка.Водитель;
					НоваяСтрока.ГСМ				= ТекСтрокаРасходГСМ.ГСМ;
					НоваяСтрока.Колонна = ТекКолоннаТС;
					НоваяСтрока.Организация = ДокументСсылка.Организация;
					НоваяСтрока.РасходПоНорме 	= ТекСтрокаРасходГСМ.РасходПоНорме;
					НоваяСтрока.РасходПоФакту 	= ТекСтрокаРасходГСМ.РасходПоФакту;
					
				Иначе
					мОстатокКСписаниюНорм		= ТекСтрокаРасходГСМ.РасходПоНорме;
					мАналоги					= уатОбщегоНазначения.уатПолучитьАналогиГСМ(ТекСтрокаРасходГСМ.ГСМ);
					Для Каждого ТекСтрокаТаблицыГСМ Из СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГСМ Цикл
						Если ТекСтрокаТаблицыГСМ.ТС = ТекСтрокаРасходГСМ.ТС Тогда
							мНайденнаяСтрока_рабочая = мАналоги.Найти(ТекСтрокаТаблицыГСМ.ГСМ, "Аналог");
							Если мНайденнаяСтрока_рабочая <> Неопределено или ТекСтрокаТаблицыГСМ.ГСМ = ТекСтрокаРасходГСМ.ГСМ Тогда
								НоваяСтрока 				= тблДвижений.Добавить();
								НоваяСтрока.Период 			= ДокументСсылка.ДатаВозвращения;
								НоваяСтрока.ТС 				= ТекСтрокаРасходГСМ.ТС;
								НоваяСтрока.Водитель 		= ДокументСсылка.Водитель;
								НоваяСтрока.ГСМ				= ТекСтрокаТаблицыГСМ.ГСМ;
								НоваяСтрока.Колонна = ТекКолоннаТС;
								НоваяСтрока.Организация = ДокументСсылка.Организация;
								Если ТекСтрокаРасходГСМ.РасходПоФакту <> 0 Тогда
									мРН	= ТекСтрокаРасходГСМ.РасходПоНорме * ТекСтрокаТаблицыГСМ.Количество /ТекСтрокаРасходГСМ.РасходПоФакту;
								Иначе
									мРН	= ТекСтрокаРасходГСМ.РасходПоНорме;
								КонецЕсли;	
								НоваяСтрока.РасходПоНорме 	= мРН;
								НоваяСтрока.РасходПоФакту 	= ТекСтрокаТаблицыГСМ.Количество;
								мОстатокКСписаниюНорм		= мОстатокКСписаниюНорм - мРН; 
							КонецЕсли;						
						КонецЕсли;						
					КонецЦикла;	
					
					// последняя копейка
					Если Окр(мОстатокКСписаниюНорм, мТочностьОстатковГСМ) <> 0 Тогда
						НоваяСтрока 				= тблДвижений.Добавить();
						НоваяСтрока.Период 			= ДокументСсылка.ДатаВозвращения;
						НоваяСтрока.ТС 				= ТекСтрокаРасходГСМ.ТС;
						НоваяСтрока.Водитель 		= ДокументСсылка.Водитель;
						НоваяСтрока.ГСМ				= ТекСтрокаРасходГСМ.ГСМ;
						НоваяСтрока.Колонна = ТекКолоннаТС;
						НоваяСтрока.Организация = ДокументСсылка.Организация;
						НоваяСтрока.РасходПоНорме 	= мОстатокКСписаниюНорм;
						НоваяСтрока.РасходПоФакту 	= 0;
					КонецЕсли;	
				КонецЕсли;	
				
			Иначе
				мОстатокКСписаниюНорм		= ТекСтрокаРасходГСМ.РасходПоНорме;
				мАналоги					= уатОбщегоНазначения.уатПолучитьАналогиГСМ(ТекСтрокаРасходГСМ.ГСМ);
				Для Каждого ТекСтрокаТаблицыГСМ Из СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГСМ Цикл
					Если ТекСтрокаТаблицыГСМ.ТС = ТекСтрокаРасходГСМ.ТС Тогда
						//МОтбор = Новый Структура("ГСМ, ТС", ТекСтрокаТаблицыГСМ.ГСМ, ТекСтрокаТаблицыГСМ.ТС);
						// мНайденныеСтроки_рабочая = мТаблицаПоСписаниюГСМ.НайтиСтроки(мОтбор);
						мНайденнаяСтрока_рабочая = мАналоги.Найти(ТекСтрокаТаблицыГСМ.ГСМ, "Аналог");
						Если мНайденнаяСтрока_рабочая <> Неопределено или ТекСтрокаТаблицыГСМ.ГСМ = ТекСтрокаРасходГСМ.ГСМ Тогда
							НоваяСтрока 				= тблДвижений.Добавить();
							НоваяСтрока.Период 			= ДокументСсылка.ДатаВозвращения;
							НоваяСтрока.ТС 				= ТекСтрокаРасходГСМ.ТС;
							НоваяСтрока.Водитель 		= ДокументСсылка.Водитель;
							НоваяСтрока.ГСМ				= ТекСтрокаТаблицыГСМ.ГСМ;
							НоваяСтрока.Колонна = ТекКолоннаТС;
							НоваяСтрока.Организация = ДокументСсылка.Организация;
							Если ТекСтрокаРасходГСМ.РасходПоФакту <> 0 Тогда
								мРН	= ТекСтрокаРасходГСМ.РасходПоНорме * ТекСтрокаТаблицыГСМ.Количество / ТекСтрокаРасходГСМ.РасходПоФакту;
							Иначе
								мРН	= ТекСтрокаРасходГСМ.РасходПоНорме;
							КонецЕсли;	
							НоваяСтрока.РасходПоНорме 	= мРН;
							НоваяСтрока.РасходПоФакту 	= ТекСтрокаТаблицыГСМ.Количество;
							мОстатокКСписаниюНорм		= мОстатокКСписаниюНорм - мРН; 
						КонецЕсли;						
					КонецЕсли;						
				КонецЦикла;	
				
				// последняя копейка
				Если Окр(мОстатокКСписаниюНорм, мТочностьОстатковГСМ) <> 0 Тогда
					НоваяСтрока 				= тблДвижений.Добавить();
					НоваяСтрока.Период 			= ДокументСсылка.ДатаВозвращения;
					НоваяСтрока.ТС 				= ТекСтрокаРасходГСМ.ТС;
					НоваяСтрока.Водитель 		= ДокументСсылка.Водитель;
					НоваяСтрока.ГСМ				= ТекСтрокаРасходГСМ.ГСМ;
					НоваяСтрока.Колонна = ТекКолоннаТС;
					НоваяСтрока.Организация = ДокументСсылка.Организация;
					НоваяСтрока.РасходПоНорме 	= мОстатокКСписаниюНорм;
					НоваяСтрока.РасходПоФакту 	= 0;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	тблДвижений.Свернуть("Период, ТС, Водитель, ГСМ, Колонна, Организация", "РасходПоНорме, РасходПоФакту");
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасходГСМ", тблДвижений);
КонецПроцедуры // СформироватьТаблицаРасходГСМ()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаИзносПробегШин(ДокументСсылка, СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Выработка.Ссылка.ДатаВозвращения КАК Период,
	|	Выработка.Ссылка.Организация КАК Организация,
	|	Выработка.ПараметрВыработки КАК ПараметрВыработки,
	|	Выработка.ТС КАК ТС,
	|	СУММА(ВЫБОР
	|			КОГДА уатМоделиШин.ИзмерениеИзносаВЧасах
	|				ТОГДА Выработка.Количество / 3600
	|			ИНАЧЕ Выработка.Количество
	|		КОНЕЦ) КАК Пробег,
	|	УстановленныеШины.СерияНоменклатуры КАК СерияНоменклатуры,
	|	СУММА(ВЫБОР
	|			КОГДА уатМоделиШин.ИзмерениеИзносаВЧасах
	|				ТОГДА уатМоделиШин.НормаЗатрат * УстановленныеШины.СерияНоменклатуры.ПервоначальнаяСтоимость / 100 * Выработка.Количество / 3600
	|			ИНАЧЕ уатМоделиШин.НормаЗатрат * УстановленныеШины.СерияНоменклатуры.ПервоначальнаяСтоимость / 100 * Выработка.Количество / 1000
	|		КОНЕЦ) КАК Износ
	|ИЗ
	|	Документ.уатТехнологическийПутевойЛист.ВыработкаТС КАК Выработка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			уатАгрегатыТССрезПоследних.Период КАК Период,
	|			уатАгрегатыТССрезПоследних.Регистратор КАК Регистратор,
	|			уатАгрегатыТССрезПоследних.СерияНоменклатуры КАК СерияНоменклатуры,
	|			уатАгрегатыТССрезПоследних.ТС КАК ТС,
	|			уатАгрегатыТССрезПоследних.МестоУстановки КАК МестоУстановки,
	|			уатАгрегатыТССрезПоследних.СостояниеАгрегата КАК СостояниеАгрегата
	|		ИЗ
	|			РегистрСведений.уатАгрегатыТС.СрезПоследних(&Дата, ) КАК уатАгрегатыТССрезПоследних
	|		ГДЕ
	|			уатАгрегатыТССрезПоследних.СостояниеАгрегата В(&СостояниеАгрегата)
	|			И уатАгрегатыТССрезПоследних.ТС В(&ВСоставе)
	|			И уатАгрегатыТССрезПоследних.СерияНоменклатуры.ТипАгрегата = &ТипАгрегата) КАК УстановленныеШины
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.уатМоделиАгрегатов КАК уатМоделиШин
	|			ПО УстановленныеШины.СерияНоменклатуры.Модель = уатМоделиШин.Ссылка
	|		ПО Выработка.ТС = УстановленныеШины.ТС
	|ГДЕ
	|	(уатМоделиШин.ИзмерениеИзносаВЧасах
	|				И Выработка.ПараметрВыработки = &ПараметрВыработкиВремяВРаботе
	|			ИЛИ НЕ уатМоделиШин.ИзмерениеИзносаВЧасах
	|				И Выработка.ПараметрВыработки = &ПараметрВыработкиПробегОбщий)
	|	И Выработка.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Выработка.Ссылка.ДатаВозвращения,
	|	Выработка.Ссылка.Организация,
	|	Выработка.ПараметрВыработки,
	|	Выработка.ТС,
	|	УстановленныеШины.СерияНоменклатуры";
	Запрос.УстановитьПараметр("Дата", Новый Граница(ДокументСсылка.ДатаВозвращения, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ВСоставе", ДокументСсылка.ВыработкаТС.ВыгрузитьКолонку("ТС"));
	СписокСостоянийАгрегата = Новый СписокЗначений();
	СписокСостоянийАгрегата.Добавить(Перечисления.уатСостоянияАгрегатов.УстановленоВРаботе);
	Если уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.НачислятьИзносНаЗапаску) Тогда
		СписокСостоянийАгрегата.Добавить(Перечисления.уатСостоянияАгрегатов.УстановленоВЗапас);
	КонецЕсли;
	Запрос.УстановитьПараметр("СостояниеАгрегата", СписокСостоянийАгрегата);
	Запрос.УстановитьПараметр("СостояниеСнято", Перечисления.уатСостоянияАгрегатов.Снято);
	Запрос.УстановитьПараметр("ТипАгрегата", Справочники.уатТипыАгрегатов.Шина);
	Запрос.УстановитьПараметр("ПараметрВыработкиПробегОбщий", Справочники.уатПараметрыВыработки.ПробегОбщий);
	Запрос.УстановитьПараметр("ПараметрВыработкиВремяВРаботе", Справочники.уатПараметрыВыработки.ВремяВРаботе);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	мТаблицаУстановленныхШин = Запрос.Выполнить().Выгрузить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаИзносаПробегаШин", мТаблицаУстановленныхШин);
КонецПроцедуры // СформироватьТаблицаИзносПробегШин()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРабочееВремяРаботниковОрганизаций(ДокументСсылка, СтруктураДополнительныеСвойства)
	Если Не уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.УчетРабочегоВремени) Тогда
		Возврат;
	КонецЕсли;
	
	мТаблица = Новый ТаблицаЗначений;
	мТаблица.Колонки.Добавить("Период");
	мТаблица.Колонки.Добавить("Сотрудник");
	мТаблица.Колонки.Добавить("Организация");
	мТаблица.Колонки.Добавить("ВидИспользованияРабочегоВремени");
	мТаблица.Колонки.Добавить("ДатаРаботы");
	мТаблица.Колонки.Добавить("Дней");
	мТаблица.Колонки.Добавить("Время");
	
	ФормированиеТаблицыРабочегоВремениДляТабеля(мТаблица, ДокументСсылка, СтруктураДополнительныеСвойства);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРабочегоВремени", мТаблица);
КонецПроцедуры // СформироватьТаблицаРабочееВремяРаботниковОрганизаций()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРасходы(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Если ПолучитьФункциональнуюОпцию("уатИспользоватьУчетДоходовИРасходов") = ЛОЖЬ Тогда
		Возврат;
	КонецЕсли;
	
	СтатьяРасходовГСМ = Неопределено;
	СтатьяРасходовШины = Неопределено;
	СтатьяРасходовЗП = Неопределено;
	Для Каждого ТекСтрока Из ДокументСсылка.ПланЗатрат.Расходы Цикл
		Если СтатьяРасходовГСМ = Неопределено И ТекСтрока.СтатьяРасходов.ВидЗатрат = Перечисления.уатВидыЗатрат.ГСМ Тогда
			СтатьяРасходовГСМ = ТекСтрока.СтатьяРасходов;
		ИначеЕсли СтатьяРасходовШины = Неопределено И ТекСтрока.СтатьяРасходов.ВидЗатрат = Перечисления.уатВидыЗатрат.Шины Тогда
			СтатьяРасходовШины = ТекСтрока.СтатьяРасходов;
		ИначеЕсли СтатьяРасходовЗП = Неопределено И ТекСтрока.СтатьяРасходов.ВидЗатрат = Перечисления.уатВидыЗатрат.ОплатаТруда Тогда
			СтатьяРасходовЗП = ТекСтрока.СтатьяРасходов;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаРасходы = Новый ТаблицаЗначений;
	ТаблицаРасходы.Колонки.Добавить("СтатьяРасходов", Новый ОписаниеТипов("СправочникСсылка.уатСтатьиРасходов"));
	ТаблицаРасходы.Колонки.Добавить("СчетРасходов",   Новый ОписаниеТипов("ПланСчетовСсылка.уатРегламентированный"));
	ТаблицаРасходы.Колонки.Добавить("ТС",             Новый ОписаниеТипов("СправочникСсылка.уатТС"));
	ТаблицаРасходы.Колонки.Добавить("СуммаРегл",      Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	ТаблицаРасходы.Колонки.Добавить("СуммаУпр",       Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	ТаблицаРасходы.Колонки.Добавить("СуммаНДС",       Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	ТаблицаРасходы.Колонки.Добавить("СуммаНДСУпр",    Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	
	Если ЗначениеЗаполнено(СтатьяРасходовГСМ) Тогда
		Для Каждого ТекСтрока Из СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГСМ Цикл
			ТекСуммаНДСУпр = ?(ТекСтрока.Стоимость = 0, 0, ТекСтрока.СуммаНДС * ТекСтрока.СтоимостьУпр / ТекСтрока.Стоимость);
			
			НоваяСтрокаВрем                = ТаблицаРасходы.Добавить();
			НоваяСтрокаВрем.СтатьяРасходов = СтатьяРасходовГСМ;
			НоваяСтрокаВрем.СчетРасходов   = СтатьяРасходовГСМ.Счет;
			НоваяСтрокаВрем.ТС             = ТекСтрока.ТС;
			НоваяСтрокаВрем.СуммаРегл      = ТекСтрока.Стоимость + ТекСтрока.СуммаНДС;
			НоваяСтрокаВрем.СуммаУпр       = ТекСтрока.СтоимостьУпр + ТекСуммаНДСУпр;
			НоваяСтрокаВрем.СуммаНДС       = ТекСтрока.СуммаНДС;
			НоваяСтрокаВрем.СуммаНДСУпр    = ТекСуммаНДСУпр;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтатьяРасходовШины) Тогда
		Для Каждого ТекСтрока Из СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаИзносаПробегаШин Цикл
			НоваяСтрокаВрем = ТаблицаРасходы.Добавить();
			НоваяСтрокаВрем.СтатьяРасходов = СтатьяРасходовШины;
			НоваяСтрокаВрем.СчетРасходов = СтатьяРасходовШины.Счет;
			НоваяСтрокаВрем.ТС = ТекСтрока.ТС;
			НоваяСтрокаВрем.СуммаРегл = ТекСтрока.Износ;
			НоваяСтрокаВрем.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(НоваяСтрокаВрем.СуммаРегл,
				СтруктураДополнительныеСвойства.ВалютаРеглУчета, СтруктураДополнительныеСвойства.ВалютаУпрУчета, ДокументСсылка.ДатаВозвращения, ДокументСсылка.ДатаВозвращения);
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаРасходы.Свернуть("СтатьяРасходов, СчетРасходов, ТС", "СуммаУпр, СуммаРегл, СуммаНДС, СуммаНДСУпр");
	
	ТекстОшибок = "";
	уатПроведение.РаспределитьЗатратыМеждуАналитиками(ДокументСсылка, ТаблицаРасходы, ТекстОшибок);
	
	ТаблицаРасходы.Колонки.Добавить("Период");
	ТаблицаРасходы.ЗаполнитьЗначения(ДокументСсылка.ДатаВозвращения, "Период");
	ТаблицаРасходы.Колонки.Добавить("Регистратор");
	ТаблицаРасходы.ЗаполнитьЗначения(ДокументСсылка, "Регистратор");
	ТаблицаРасходы.Колонки.Добавить("Организация");
	ТаблицаРасходы.ЗаполнитьЗначения(ДокументСсылка.Организация, "Организация");
	ТаблицаРасходы.ЗаполнитьЗначения(ДокументСсылка.Подразделение, "Подразделение");
	ТаблицаРасходы.ЗаполнитьЗначения(ДокументСсылка.ОбъектСтроительства, "ОбъектСтроительства");
		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасходы", ТаблицаРасходы);
КонецПроцедуры // СформироватьТаблицаРасходы()

#КонецОбласти

#КонецОбласти


#КонецЕсли