
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтотОбъект);
	
	ЭтоОстаток = Найти(ТипИтога,"Сальдо")> 0;
	Элементы.ГраницаПериода.Видимость = ЭтоОстаток;
	ТекущийВидИтога = ЭтоОстаток;
	Если ЗначениеЗаполнено(СчетПланаСчетов) Тогда
		НаименованиеСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетПланаСчетов, "Наименование");
		Элементы.СчетПланаСчетов.ОграничениеТипа = ФинансоваяОтчетностьСервер.ОписаниеТипаПоЗначению(СчетПланаСчетов); 
	КонецЕсли;
	Элементы.ГруппаДопРеквизиты.Видимость = Параметры.ПоказатьКодСтрокиПримечание;
	Элементы.ОбратныйЗнак.Видимость = Параметры.ПоказатьКодСтрокиПримечание;
	Элементы.ВыделитьЭлемент.Видимость = Параметры.ПоказатьКодСтрокиПримечание;
	ОбновитьЗаголовокФормы();

	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеДляПечатиПриИзменении(Элемент)
	
	Объект.Наименование = Объект.НаименованиеДляПечати;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипИтогаПриИзменении(Элемент)
	
	ЭтоОстаток = Найти(Элемент.ТекстРедактирования,"Сальдо")> 0;
	Элементы.ГраницаПериода.Видимость = ЭтоОстаток;
	Если ТекущийВидИтога <> ЭтоОстаток Тогда
		НастроитьПолеОтбора();
	КонецЕсли;
	ТекущийВидИтога = ЭтоОстаток;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПланаСчетовПриИзменении(Элемент)
	
	СчетПланаСчетовПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СчетПланаСчетовПриИзмененииСервер()
	
	// По умолчанию заполняем НаименованиеДляПечати по НаименованиюСчета, 
	// пока пользователь не введет свое наименование для печати
	НовоеНаименованиеСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетПланаСчетов, "Наименование");
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеДляПечати)
		ИЛИ Объект.НаименованиеДляПечати = НаименованиеСчета Тогда
		Объект.НаименованиеДляПечати = НовоеНаименованиеСчета;
	КонецЕсли;
	Объект.Наименование = Объект.НаименованиеДляПечати;
	НаименованиеСчета = НовоеНаименованиеСчета;
	НастроитьПолеОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	ПредставлениеТипа = НСтр("en='Монетарный показатель';ru='Монетарный показатель'");
	Если (Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено) И ТипЗнч(СчетПланаСчетов) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
		ПредставлениеТипа = НСтр("en='Монетарный показатель регламентированный';ru='Монетарный показатель регламентированный'");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеДляПечати) Тогда
		ЭтотОбъект.Заголовок = ПредставлениеТипа + НСтр("en=' (создание)';ru=' (создание)'"); ;
	Иначе
		ЭтотОбъект.Заголовок = Объект.НаименованиеДляПечати + " (" + ПредставлениеТипа + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПолеОтбора()
	
	Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(ЭтотОбъект, ЭтотОбъект.Компоновщик, Объект.ВидЭлемента, Компоновщик.Настройки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
